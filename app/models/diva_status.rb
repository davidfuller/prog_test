class DivaStatus < ActiveRecord::Base

  has_many :diva_datas
  has_many :diva_logs

  default_scope :order => :value

  def self.diva_workflow_message_to_status(message)
    if message == ''
      find_by_message('Awaiting Response')
    elsif message == 'Queued'
      find_by_message ('Transfer requested')
    elsif message == 'Completed'
      find_by_message('Transfer Complete')
    elsif message == 'Not Available'
      find_by_message('Not Available')
    elsif message == 'Failed'
      find_by_message('Diva Transfer Failed')
    else
      find_by_message('Transfer in progress')
    end
  end
end
