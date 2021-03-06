ActiveRecord::VirtualEnumerations.define do |config|

  # A single definition  
  #config.define :booking_status

  # which is the same as 
  #config.define 'BookingStatus'

  # You can specify the table that holds your records
  #config.define :booking_status, :table_name => 'bstatus_values'
  
  # You can define the superclass of your enumeration allowing 
  # you to store your enumeration records in an STI table.
  #config.define :booking_status, :extends => 'EnumRecord'

  # Note that EnumRecord can be a virtual enumeration or it 
  # can be a regular model that acts_as_enumerated.

  # You can also specify the order of the 'all' list 
  #config.define :booking_status, :order => 'position ASC'
  
  # And, if you have a bunch of enumerations that all use the same
  # options, you can just pass an array as the first arg to define()
  #config.define [:booking_status, :payment_status], 
  #    :order => 'position ASC',
  #    :extends => 'EnumRecord'

  # You can pass a block to define() that will be class_eval'd
  # by the enumeration class after it's been defined (or reloaded).
  #config.define :booking_status, :extends => 'EnumRecord' do
  #  acts_as_list
  #  def some_method(arg)
  #    # an instance method
  #  end
  #end      
  
  # And finally, a little hint that you can use the block to
  # define singleton methods, especially handy because in 
  # development mode your ActiveRecord subclasses are destroyed
  # after each request.  Putting your singleton methods in the
  # define() block guarantees that they'll be created every time
  # the enumeration classes are reloaded.
  config.define :option_operation do 
    class << self[:add]
      def apply(x,y)
        x + y
      end
    end
    
    class << self[:subtract]
      def apply(x,y)
        x - y
      end
    end
  end
  
end
