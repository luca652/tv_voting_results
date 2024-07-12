namespace :import do
  desc "Import log data from a file"
  task :logs, [:filename] => :environment do |t, args|
    filename = args[:filename]

    File.open(filename, "r:UTF-8") do |file|
      file.each_line do |line|

        next unless valid_log_line?(line.chomp)

        parts = line.split
        campaign_name = parts[2].split(':')[1]
        validity = parts[3].split(':')[1]
        choice = parts[4].split(':')[1]

        campaign = Campaign.find_or_create_by!(name: campaign_name)

        campaign.votes.create!(
          validity: validity,
          choice: choice
        )

        puts "Created Vote for Campaign: #{campaign_name}"
      end
    end
  rescue ArgumentError => e
    puts "Invalid byte sequence in file: #{filename}"
    puts e.message
  end

  def valid_log_line?(line)
    parts = line.split
    return false unless parts.size == 9
    return false unless parts[0] == 'VOTE'
    return false unless parts[1].to_i.to_s == parts[1]

    required_keys = ['Campaign:', 'Validity:', 'Choice:', 'CONN:', 'MSISDN:', 'GUID:', 'Shortcode:']
    parts[2..].each_with_index do |part, index|
      return false unless part.start_with?(required_keys[index])
    end

    true
  end
end
