desc 'Load lines and stops'
    task :load_data => :environment do
            
      require "fastercsv"
      FasterCSV.read("#{RAILS_ROOT}/lib/db/lines.csv").each do |row|
        id, label, name, course, created_at, updated_at, color = row
        Line.create(:label => label, :name => name, :course => course, :color => color).save
      end
      FasterCSV.read("#{RAILS_ROOT}/lib/db/stops.csv").each do |row|
        id, node, name, lat, lng = row
        Stop.create(:node => node, :name => name, :lat => lat, :lng => lng).save
      end

    end
