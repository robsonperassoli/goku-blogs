defmodule Boc.Layout do
  require EEx

  EEx.function_from_file(:def, :render, Path.join(Boc.priv_path(), "layout.html.eex"), [:article])

  def home?(article), do: article.key == "home"

  def article_title(article) do
    article.meta["title"]
  end

  def publication_date(article) do
    format_date(article.meta["publication_date"] || article.meta["date"])
  end

  def tags(article) do
    case article.meta["tags"] do
      list when is_list(list) -> list
      _ -> []
    end
  end

  defp format_date(nil), do: nil

  defp format_date(%Date{} = date) do
    "#{Calendar.strftime(date, "%B")} #{date.day}, #{date.year}"
  end

  defp format_date(%NaiveDateTime{} = datetime) do
    format_date(NaiveDateTime.to_date(datetime))
  end

  defp format_date(%DateTime{} = datetime) do
    format_date(DateTime.to_date(datetime))
  end

  defp format_date(string) when is_binary(string) do
    case Date.from_iso8601(string) do
      {:ok, date} -> format_date(date)
      _ -> string
    end
  end

  defp format_date(_), do: nil
end
