
# Install the scope images
install(
  FILES
    "icon.png"
    "logo.png"
    "screenshot.png"
    "departments.json"
  DESTINATION
    "${SCOPE_INSTALL_DIR}"
)

INSTALL(
    DIRECTORY "images"
    DESTINATION ${SCOPE_INSTALL_DIR}
)

INSTALL(
    DIRECTORY "renderer"
    DESTINATION ${SCOPE_INSTALL_DIR}
)

