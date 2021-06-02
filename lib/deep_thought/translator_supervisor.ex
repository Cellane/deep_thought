defmodule DeepThought.TranslatorSupervisor do
  def translate(event_details, reaction, channel_id, message_ts) do
    Task.Supervisor.start_child(
      __MODULE__,
      DeepThought.DeepL.Translator,
      :translate,
      [event_details, reaction, channel_id, message_ts],
      restart: :transient
    )
  end

  def simple_translate(channel_id, text, username) do
    Task.Supervisor.start_child(
      __MODULE__,
      DeepThought.DeepL.SimpleTranslator,
      :simple_translate,
      [channel_id, text, username],
      restart: :transient
    )
  end
end
