namespace :import do
  desc "Import log data from a file"
  task :logs, [:filename] => :environment do |t, args|
    filename = args[:filename]
    valid_votes = 0
    invalid_lines = 0

    File.open(filename, "r:ASCII-8BIT:UTF-8") do |file|
      file.each_line.with_index(1) do |line, line_number|
        line.strip!

        unless valid_log_line?(line)
          puts "Invalid line format at line #{line_number}: #{line}"
          invalid_lines += 1
          next
        end

        begin
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

          valid_votes += 1
        rescue => e
          puts "Error processing line #{line_number}: #{e.message}"
          puts "Line content: #{line}"
          invalid_lines += 1
        end
      end
    end

    puts "Import completed. Valid votes: #{valid_votes}, Invalid lines: #{invalid_lines}"
  end

  def valid_log_line?(line)
    parts = line.split
    has_nine_parts?(parts) &&
    starts_with_vote?(parts) &&
    second_element_is_ten_digit_number?(parts) &&
    all_keys_are_present_in_the_right_order?(parts) &&
    all_keys_have_expected_value?(parts)
  end

  def has_nine_parts?(parts)
    parts.size == 9
  end

  def starts_with_vote?(parts)
    parts[0] == 'VOTE'
  end

  def second_element_is_ten_digit_number?(parts)
    parts[1].to_i.to_s == parts[1] && parts[1].length == 10
  end

  def all_keys_are_present_in_the_right_order?(parts)
    required_keys = ['Campaign:', 'Validity:', 'Choice:', 'CONN:', 'MSISDN:', 'GUID:', 'Shortcode:']
    parts[2..].each_with_index do |part, index|
      return false unless part.start_with?(required_keys[index])
    end
    true
  end

  def all_keys_have_expected_value?(parts)
    parts[2..].each do |part|
      key, value = part.split(':', 2)
      return false unless key == 'Choice' || value && !value.empty?
    end
    true
  end
end
