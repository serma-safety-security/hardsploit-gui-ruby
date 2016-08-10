class Use < ActiveRecord::Base
	# Associations
	belongs_to	:signall,
		foreign_key:	"signal_id"
	belongs_to :bus
end
