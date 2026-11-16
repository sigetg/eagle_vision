# A request's form answers are stored as JSON in its description

The API gives a request one free-text description (`descr.plain`) and one formatted field (`descr.formatted`), and no fields for class year, major or reason. The 2024 code joined the answers with a literal backslash-n (`'\n'` in single quotes) and split them again in each view. New requests store the student's answers as a JSON object in `descr.plain`, and the staff message in `descr.formatted`. Reading falls back to the old backslash-n format so 2024 requests still display.
