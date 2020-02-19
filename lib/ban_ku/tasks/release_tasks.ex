defmodule(BanKu.Tasks.ReleaseTasks) do
  @moduledoc """
  Tasks to be run during release on runtime
  """

  @start_apps [
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]
  @logger_module :logger
  @otp_app :ban_ku

  @seeds_file "seeds.exs"

  alias BanKu.Repo
  alias Ecto.Migrator
  require Logger

  def setup(_opts \\ []) do
    # Can't do any logs here since we havent started logger
    start(:logger)

    Logger.info("#> Booting Application")
    start(:app)

    Logger.info("#> Starting Application Dependencies")
    start(:app_dependencies)

    Logger.info("#> Starting Database Connection")
    start(:database_connection)

    Logger.info("#> Running Migrations")
    run_migrations()

    Logger.info("#> Running Seeds")
    run_seed(@seeds_file)

    Logger.info("#> Finished release tasks, application will start soon... Time for a ☕️")
  end

  defp start(:logger), do: Application.ensure_started(@logger_module)

  defp start(:database_connection), do: {:ok, _} = Repo.start_link(pool_size: 10)

  defp start(:app), do: Application.load(@otp_app)

  defp start(:app_dependencies) do
    Enum.each(@start_apps, fn app ->
      result = Application.ensure_all_started(app)
      Logger.info("#> Starting: #{app} - #{inspect(result)}")
    end)
  end

  defp run_migrations,
    do: Migrator.run(Repo, Migrator.migrations_path(Repo), :up, all: true, log: :debug)

  def run_seed(filename) do
    seed_file = priv_path_for(filename)

    if File.exists?(seed_file) do
      Logger.info("")
      Logger.info("Seeding: #{filename}")
      Code.eval_file(seed_file)
      Logger.info("  > Finished")
    else
      Logger.error("#> ERROR: Seed file #{filename} not found")
    end
  end

  defp priv_path_for(filename) do
    app = Keyword.get(Repo.config(), :otp_app)

    repo_underscore =
      Repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join(["#{:code.priv_dir(app)}", repo_underscore, filename])
  end
end
