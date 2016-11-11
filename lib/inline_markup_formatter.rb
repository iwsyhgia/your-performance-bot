# Class is required to generate required keyboard markup
class InlineMarkupFormatter
  SLICE_SIZE = 1

  class << self
    def markup(button_names, data, callback_name)
      buttons = to_buttons(button_names, data, callback_name)
      add_cancel_button(buttons, callback_name)

      to_keyboard(buttons)
    end

    private

    def add_cancel_button(buttons, callback_name)
      name = [I18n.t("buttons.cancel")]
      data = ["cancel"]
      buttons << to_buttons(name, data, callback_name).first
    end

    def to_buttons(button_names, data, callback_name)
      button_names.map.with_index do |element, index|
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: element,
          callback_data: [callback_name, data[index]].join(";")
        )
      end
    end

    def to_keyboard(buttons)
      Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: make_markup(buttons)
      )
    end

    def make_markup(buttons)
      buttons.each_slice(SLICE_SIZE).to_a
    end
  end
end
