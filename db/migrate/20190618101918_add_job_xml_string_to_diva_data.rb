class AddJobXmlStringToDivaData < ActiveRecord::Migration
  def self.up
    add_column :diva_datas, :job_xml_string, :text
  end

  def self.down
    remove_column :diva_datas, :job_xml_string
  end
end
