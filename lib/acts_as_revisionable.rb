require 'active_record'
require 'active_support'

module ActsAsRevisionable
  
  autoload :RevisionRecord, File.expand_path('../acts_as_revisionable/revision_record', __FILE__)
  
  def self.included(base)
    base.extend(ActsMethods)
  end
  
  module ActsMethods
    # Calling acts_as_revisionable will inject the revisionable behavior into the class. Specifying a :limit option
    # will limit the number of revisions that are kept per record. Specifying :minimum_age will ensure that revisions are
    # kept for at least a certain amount of time (i.e. 2.weeks). Associations to be revisioned can be specified with
    # the :associations option as an array of association names. To specify associations of associations, use a hash
    # for that association with the association name as the key and the value as an array of sub associations.
    # For instance, this declaration will revision <tt>:tags</tt>, <tt>:comments</tt>, as well as the
    # <tt>:ratings</tt> association on <tt>:comments</tt>:
    #
    #   :associations => [:tags, {:comments => [:ratings]}]
    #
    # You can also pass an options of <tt>:on_update => true</tt> to automatically enable revisioning on every update.
    # Otherwise you will need to perform your updates in a store_revision block. The reason for this is so that
    # revisions for complex models with associations can be better controlled.
    #
    # You can keep a revisions of deleted records by passing <tt>:dependent => :keep</tt>. When a record is destroyed,
    # an additional revision will be created and marked as trash. Trash records can be deleted by calling the
    # <tt>empty_trash</tt> method. You can set <tt>:on_destroy => true</tt> to automatically create the trash revision
    # whenever a record is destroyed. It is recommended that you turn both of these features on.
    #
    # Revision records have an optional +label+ field which can be used for display purposes to distinguish revisions
    # in a view. This value will only be set if you provide a Proc for the <tt>:label</tt> option to the +acts_as_revisionable+
    # call. The proc will be yielded to with the record before it is revisioned.
    #
    #   acts_as_revisionable :label => lambda{|record| "Updated by #{record.updated_by} at #{record.updated_at}"}
    #
    # A has_many :revision_records will also be added to the model for accessing the revisions.
    def acts_as_revisionable(options = {})
      class_attribute :acts_as_revisionable_options, :instance_writer => false, :instance_reader => false
      self.acts_as_revisionable_options = options.clone
        extend ClassMethods
      include InstanceMethods
      has_many_options = {:as => :revisionable, :order => 'revision DESC', :class_name => "ActsAsRevisionable::RevisionRecord"}
      has_many_options[:dependent] = :destroy unless options[:dependent] == :keep
      has_many :revision_records, has_many_options
      alias_method_chain :update, :revision if options[:on_update]
      alias_method_chain :destroy, :revision if options[:on_destroy]
    end
  end
  
  module ClassMethods
    # Get a revision for a specified id.
    def revision(id, revision_number)
      RevisionRecord.find_revision(self, id, revision_number)
    end
    
    # Get the last revision for a specified id.
    def last_revision(id)
      RevisionRecord.last_revision(self, id)
    end
    
    # Load a revision for a record with a particular id. Associations added since the revision
    # was created will still be in the restored record.
    # If you want to save a revision with associations properly, use restore_revision!
    def restore_revision(id, revision_number)
      revision_record = revision(id, revision_number)
      return revision_record.restore if revision_record
    end

    # Load a revision for a record with a particular id and save it to the database. You should
    # always use this method to save a revision if it has associations.
    def restore_revision!(id, revision_number)
      record = restore_revision(id, revision_number)
      if record
        record.store_revision do
          save_restorable_associations(record, revisionable_associations)
        end
      end
      return record
    end
    
    # Load the last revision for a record with the specified id. Associations added since the revision
    # was created will still be in the restored record.
    # If you want to save a revision with associations properly, use restore_last_revision!
    def restore_last_revision(id)
      revision_record = last_revision(id)
      return revision_record.restore if revision_record
    end

    # Load the last revision for a record with the specified id and save it to the database. You should
    # always use this method to save a revision if it has associations.
    def restore_last_revision!(id)
      record = restore_last_revision(id)
      if record
        record.store_revision do
          save_restorable_associations(record, revisionable_associations)
        end
      end
      return record
    end
    
    # Returns a hash structure used to identify the revisioned associations.
    def revisionable_associations(options = acts_as_revisionable_options[:associations])
      return nil unless options
      options = [options] unless options.kind_of?(Array)
      associations = {}
      options.each do |association|
        if association.kind_of?(Symbol)
          associations[association] = true
        elsif association.kind_of?(Hash)
          association.each_pair do |key, value|
            associations[key] = revisionable_associations(value)
          end
        end
      end
      return associations
    end
    
    # Delete all revision records for deleted items that are older than the specified maximum age in seconds.
    def empty_trash(max_age)
      RevisionRecord.empty_trash(self, max_age)
    end
    
    private
    
    def save_restorable_associations(record, associations)
      record.class.transaction do
        if associations.kind_of?(Hash)
          associations.each_pair do |association, sub_associations|
            associated_records = record.send(association)
            reflection = record.class.reflections[association].macro
            
            if reflection == :has_and_belongs_to_many
              associated_records = associated_records.collect{|r| r}
              record.send(association, true).clear
              associated_records.each do |assoc_record|
                record.send(association) << assoc_record
              end
            else
              if reflection == :has_many
                existing = associated_records.all
                existing.each do |existing_association|
                  associated_records.delete(existing_association) unless associated_records.include?(existing_association)
                end
              end
            
              associated_records = [associated_records] unless associated_records.kind_of?(Array)
              associated_records.each do |associated_record|
                save_restorable_associations(associated_record, sub_associations) if associated_record
              end
            end
          end
        end
        record.save! unless record.new_record?
      end
    end
  end
  
  module InstanceMethods
    # Restore a revision of the record and return it. The record is not saved to the database. If there
    # is a problem restoring values, errors will be added to the record.
    def restore_revision(revision_number)
      self.class.restore_revision(self.id, revision_number)
    end
    
    # Restore a revision of the record and save it along with restored associations.
    def restore_revision!(revision_number)
      self.class.restore_revision!(self.id, revision_number)
    end
    
    # Get a specified revision record
    def revision(revision_number)
      self.class.revision(id, revision_number)
    end
    
    # Get the last revision record
    def last_revision
      self.class.last_revision(id)
    end
    
    # Call this method to implement revisioning. The object changes should happen inside the block.
    def store_revision
      if new_record? || @revisions_disabled
        return yield
      else
        retval = nil
        revision = nil
        begin
          RevisionRecord.transaction do
            begin
              read_only = self.class.first(:conditions => {self.class.primary_key => self.id}, :readonly => true)
              if read_only
                revision = read_only.create_revision!
                truncate_revisions!
              end
            rescue => e
              puts e
              logger.warn(e) if logger
            end
            
            disable_revisioning do
              retval = yield
            end
            
            raise ActiveRecord::Rollback unless errors.empty?
            
            revision.trash! if destroyed?
          end
        rescue => e
          # In case the database doesn't support transactions
          if revision
            begin
              revision.destroy
            rescue => e
              puts e
              logger.warn(e) if logger
            end
          end
          raise e
        end
        return retval
      end
    end
    
    # Create a revision record based on this record and save it to the database.
    def create_revision!
      revision = RevisionRecord.new(self, acts_as_revisionable_options[:encoding])
      if self.acts_as_revisionable_options[:label].is_a?(Proc)
        revision.label = self.acts_as_revisionable_options[:label].call(self)
      end
      revision.save!
      return revision
    end
    
    # Truncate the number of revisions kept for this record. Available options are :limit and :minimum_age.
    def truncate_revisions!(options = nil)
      options = {:limit => acts_as_revisionable_options[:limit], :minimum_age => acts_as_revisionable_options[:minimum_age]} unless options
      RevisionRecord.truncate_revisions(self.class, self.id, options)
    end
    
    # Disable the revisioning behavior inside of a block passed to the method.
    def disable_revisioning
      save_val = @revisions_disabled
      retval = nil
      begin
        @revisions_disabled = true
        retval = yield if block_given?
      ensure
        @revisions_disabled = save_val
      end
      return retval
    end
    
    # Destroy the record while recording the revision.
    def destroy_with_revision
      store_revision do
        destroy_without_revision
      end
    end
    
    private
    
    # Update the record while recording the revision.
    def update_with_revision
      store_revision do
        update_without_revision
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsRevisionable)
