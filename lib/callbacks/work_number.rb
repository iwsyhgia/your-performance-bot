module Bot
  module Callback
    class WorkNumber < Base # :nodoc:
      def should_start?
        data.first =~ %r{work_number}
      end

      def start
        validate_work_number(subject, work_number)
        subject.update(accepted_numbers: subject.accepted_numbers << work_number)

        edit_message(callback_response("confirmation"))
      end

      private

      def validate_work_number(subject, value)
        return if subject.remaining_numbers.include?(value)

        fail(BotError, "work_number_not_found")
      end

      def subject
        @subject ||= user.subjects.find(name: subject_name).first
      end

      def subject_name
        SubjectNameParser.parse(data[1])
      end

      def work_number
        @work_number ||= NumberParser.parse(data[2])
      end
    end
  end
end
