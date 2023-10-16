defmodule TextClient.Impl.Player do

  @typep game :: Hangman.Type.game
  @typep tally :: Hangman.Type.tally
  @typep state :: { game, tally }

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)

    interact({ game, tally })
  end

  @spec interact(state) :: :ok
  def interact({ _game, tally = %{ game_state: :won } }) do
    IO.puts IO.ANSI.green <> "Congratulations. You won! The word is #{tally.letters |> Enum.join}" <> IO.ANSI.reset()
  end

  def interact({ _game, tally = %{ game_state: :lost } }) do
    IO.puts IO.ANSI.red <> "Sorry, you lost... the word was #{tally.letters |> Enum.join}" <> IO.ANSI.reset()
  end

  def interact({ game, tally}) do
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)

    new_tally = Hangman.make_move(game, get_guess())
    interact({ game, new_tally })
  end

  def feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(%{ game_state: :good_guess }), do: "Good guess!"
  def feedback_for(%{ game_state: :bad_guess }), do: "Sorry, that letter's not in the word"
  def feedback_for(%{ game_state: :already_used }), do: "You already used that letter"

  def current_word(tally) do
    [
      "Word so far: ", tally.letters |> Enum.join(" "),
      IO.ANSI.green  <> "   (turns left: " <> IO.ANSI.reset(),
      IO.ANSI.blue   <> (tally.turns_left |> to_string) <> IO.ANSI.reset(),
      IO.ANSI.green  <> ", used so far: " <> IO.ANSI.reset(),
      IO.ANSI.yellow <> (tally.used |> Enum.join(",")) <> IO.ANSI.reset(),
      IO.ANSI.green  <> ")" <> IO.ANSI.reset(),
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
