run_eda <- function(stroke, figures_dir) {
  ensure_directories(figures_dir)

  plots <- list(
    age_distribution = ggplot2::ggplot(stroke, ggplot2::aes(x = age)) +
      ggplot2::geom_histogram(binwidth = 5, boundary = 0) +
      ggplot2::labs(
        title = "Age distribution",
        x = "Age",
        y = "Count"
      ) +
      ggplot2::theme_minimal(),

    bmi_by_history = ggplot2::ggplot(
      stroke |> dplyr::filter(!is.na(stroke_history)),
      ggplot2::aes(x = factor(stroke_history), y = bmi, fill = factor(stroke_history))
    ) +
      ggplot2::geom_boxplot(show.legend = FALSE) +
      ggplot2::labs(
        title = "BMI by stroke history",
        x = "Stroke history",
        y = "BMI"
      ) +
      ggplot2::theme_minimal(),

    stress_by_history = stroke |>
      dplyr::filter(!is.na(stroke_history), !is.na(stress_level)) |>
      dplyr::mutate(stroke_history = factor(stroke_history, labels = c("No stroke", "Stroke"))) |>
      ggplot2::ggplot(ggplot2::aes(x = stress_level, fill = stroke_history)) +
      ggplot2::geom_density(alpha = 0.45) +
      ggplot2::labs(
        title = "Stress-level distribution by stroke history",
        x = "Stress level",
        fill = "Stroke history"
      ) +
      ggplot2::theme_minimal()
  )

  for (name in names(plots)) {
    ggplot2::ggsave(
      filename = file.path(figures_dir, paste0(name, ".png")),
      plot = plots[[name]],
      width = 8,
      height = 5,
      dpi = 150
    )
  }

  invisible(plots)
}
