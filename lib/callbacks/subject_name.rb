module Bot
  module Callback
    class SubjectName < Base # :nodoc:
      def should_start?
        data.first =~ %r{subject_name}
      end

      def start
        fail(BotError, "subject_not_found") unless user.subject_exist?(subject_name)

        edit_message(
          callback_response("work_number_question"),
          reply_markup: remaining_numbers_markup(subject_name)
        )
      end

      private

      def subject(name)
        user.subjects.find(name: name).first
      end

      def remaining_numbers_markup(name)
        numbers = subject(name).remaining_numbers.map(&:to_s)
        callback_data = numbers.map { |n| "#{name};#{n}"}
        InlineMarkupFormatter.markup(numbers, callback_data, next_callback_name)
      end

      def subject_name
        SubjectNameParser.parse(data[1])
      end

      def next_callback_name
        "work_number"
      end
    end
  end
end
