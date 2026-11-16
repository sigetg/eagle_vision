# The app stays server-rendered Rails with Turbo, styled with plain CSS tokens

Pages are ERB views; Turbo Frames update parts of a page in place (deciding on a request, applying filters) and Stimulus adds small behaviours. There is no React front end: the goal is depth in Rails, and React practice happens in a separate project. Styling is plain CSS on a small set of design tokens (BC maroon as the accent, not the background), with no Tailwind or Bootstrap, and each screen is restyled in the PR that rebuilds its feature rather than in one big restyle.
