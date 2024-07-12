# README

CAMPAIGN AND VOTE MODELS
Since I had to display campaigns and votes in the index page and show page, I decided to create two models in the my rails app: Campaign and Vote. A campaign has many votes and a vote belongs to a campaign. This way we can access all the votes for a campaign with @campaign.votes.

The Campaign model has one attribute: 'name'. 'name' is validated for presence and uniqueness. Uniqueness ensures that when importing logs we don't create duplicate records.

The Vote model has three attributes: 'validity', 'choice', and the foreign key 'campaign_id'. I decided not to include other attributes as they are not relevant to this task.

I also added methods to the Campaign model, which are used in the campaigns controller to set the instance variables @results and @invalid_count in the show action.
- valid_votes returns a collection of votes that have a validity of 'during' and the attribute 'choice' is neither 'nil' nor ''
- invalid_votes returns a collection of votes that have a validity of 'pre' or 'post' or the attribute 'choice' is set to 'nil' or ''
- results returns the valid votes are groups them by candidate

PARSING
I created a rake task that deals with the parsing of the log data. It iterates over each line of the votes.txt file and validates it in the 'valid_log_line?' method.

'valid_log_line?' checks that:
- when calling 'split' on the line the size of the array returned is 9 (as that is the size we expect from a well-formed line). 'split' separates the string on the ' ' delimiter and returns an array of substrings.
- the line starts with 'VOTE'
- the second element in the array (the epoch time) is a string made up of integers. This check can be improved by checking if a valid epoch time was entered.
- all the keys are present and in the correct order

If 'valid_log_line?' returns false, the line is skipped and no object is created.

If it returns true, the rest of the script extracts the values of 'campaign_name', 'validity' and 'choice' from the array.

The script then uses the find_or_create_by! method to either find an existing instance of Campaign based on its unique 'name' or create a new instance if no records exists with that 'name'.

After this, the Vote instance is created with the data extracted.

TESTS
I have added RSpec model tests for Campaign and Vote.
