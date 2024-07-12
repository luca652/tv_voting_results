namespace :import do
  desc "Import log data from a file"
  task :logs, [:filename] => :environment do |t, args|
    File.foreach(args[:filename]) do |line|
      next unless valid_log_line?(line)

      parts = line.split
      campaign_name = parts[2].split(':')[1]
      validity = parts[3].split(':')[1]
      choice = parts[4].split(':')[1]

      campaign = Campaign.find_or_create_by!(name: campaign_name)

      Vote.create!(
        campaign: campaign,
        validity: validity,
        choice: choice
      )
    end
  end

  def valid_log_line?(line)
    parts = line.split
    return false unless parts.size == 8
    return false unless parts[0] == 'VOTE'
    return false unless parts[1].to_i.to_s == parts[1] # Checks if it's a valid integer

    required_keys = ['Campaign:', 'Validity:', 'Choice:', 'CONN:', 'MSISDN:', 'GUID:', 'Shortcode:']
    parts[2..].each_with_index do |part, index|
      return false unless part.start_with?(required_keys[index])
    end

    true
  end
end
