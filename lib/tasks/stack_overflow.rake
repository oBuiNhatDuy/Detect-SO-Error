require 'gingerice'

namespace :stack_overflow do
  desc "get new question"
  task get_new_question: :environment do
    agent = Mechanize.new
    result = HTTParty.get(ENV["stack_overflow_questions_api_endpoint"])
    questions = result["items"]
    
    questions.each do |question|
      parser = Gingerice::Parser.new
      question_link = question["link"]
      question_page = agent.get(question_link)
      question_text = question_page.search('//*[@id="question"]/div/div[2]/div[1]').text.gsub(/[\r\n]/, "")
      error_result = parser.parse question_text
      if error_result.length > 4
        body_message = "[To:3821319]\nNew question to edit " + question_link
        result = HTTParty.post("https://api.chatwork.com/v2/rooms/" + ENV["chatwork_room_to_push_notifications"] + "/messages",
          headers: { "X-ChatWorkToken": ENV["x_chatwork_token"] },
          body: { "body": body_message } )
      end
    end
  end
end
