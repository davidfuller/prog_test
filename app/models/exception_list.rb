class ExceptionList < ActiveRecord::Base

default_scope :order => :entry_time

	def add_details(channel, existing, cs_title, eidr, house, message)
	
		self.entry_time = Time.now
		self.channel_name = channel
		self.existing_title = existing
		self.clipsource_title = cs_title
		self.eidr = eidr
		self.house_number = house
		self.message = message

	end

	def self.to_csv(params)

		if Useful.date?(params[:start_date])
			start_date = Date.parse(params[:start_date]).strftime('%F')
			records = all :conditions => ['DATE(entry_time) >= ?', start_date]
		else
			records = all
		end
	
		if records
			columns = %w{entry_time channel_name message existing_title clipsource_title house_number eidr}
			output = "\xEF\xBB\xBF" + columns.join(",") + "\n"	
			records.each do |r| 
				line = r.attributes.values_at(*columns)
				processed = []
				line.each do |value|
					processed <<	'"' + value.to_s.gsub('"', '""') + '"'
				end
				output << processed.join(",") + "\n"
			end
			output
		end

	end

	def self.after_this_date(params)
		
		if Useful.date?(params[:start_date])
			start_date = Date.parse(params[:start_date]).strftime('%F')
		else
			start_date = Date.today.strftime('%F')
		end
	
		paginate  :per_page => 12, :page =>params[:page],
									:conditions => ['DATE(entry_time) >= ?', start_date]
	
	end
end
