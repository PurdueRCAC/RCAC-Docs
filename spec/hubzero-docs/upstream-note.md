# Upstream defects note — DRAFT, not sent

Draft for Geoffrey to send to Nick Kisseberth (nkissebe@purdue.edu) about defects found in
`hubzero-cms` `docs/` at `9c1a8c67` during this port (TECH P3, P6). Nothing here changes the
port; it records what goes back upstream.

---

**Subject:** Two defects in hubzero-cms docs/ (found during the RCAC port)

Porting the books into docs.rcac.purdue.edu turned up two defects in `docs/` at 9c1a8c67. Both
are upstream, so the fix belongs there.

1. `docs/users/18-publications.md`, the Assign row of the curation table: "*Assigned to
   <name>*" - `<name>` is read as an HTML tag, so readers see only "Assigned to" (on
   hubzero.github.io too). Backticks or `&lt;name&gt;` fix it.

2. `docs/reference/events/user.md` (line 157) links
   `core/components/com_cart/site/controllers/test.php#L197`, which isn't in the tree at that
   commit. I think the generator ran against a checkout with an untracked file, so regenerating
   from a clean checkout should drop it. For now the port links the controllers directory.

Can you fold these into your next pass on the docs? If the fixes land before the handover, I'll
pull them in with the touch-up re-import.

GL
