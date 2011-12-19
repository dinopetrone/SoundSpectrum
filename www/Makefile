PROJECT_DIR = .
JS_SRC   = resources/js
JS_LIB_SRC = resources/js/lib
JS_DEFAULT_MODULE_NAME = project-blam.min.js
CSS_SRC  = resources/css/src
CSS_OUT  = resources/css
IMG_SRC  = resources/img
VIEW_SRC = 
VIEW_EXT = .php
TMP_DIR  = ../build
TOOLS_DIR = ../tools


################ DO NOT TOUCH BEYOND THIS POINT ################

CSS_FILES := $(filter-out $(wildcard $(PROJECT_DIR)/$(CSS_SRC)/_*.scss), $(wildcard $(PROJECT_DIR)/$(CSS_SRC)/*.scss))
JS_FILES  := $(filter-out $(wildcard $(PROJECT_DIR)/$(JS_SRC)/_*.scss), $(wildcard $(PROJECT_DIR)/$(JS_SRC)/*.scss))

define findallviews
VIEW_FILES += $$(shell find $$(PROJECT_DIR)/$$(VIEW_SRC) -type f -name '*$(1)')
endef

$(foreach EXT, $(VIEW_EXT), $(eval $(call findallviews,$(EXT))))

new: newdirs get-mustache get-jquery

newdirs:
	$(info Creating Project Directories...)
	@mkdir -p $(PROJECT_DIR)/$(CSS_OUT)
	@mkdir -p $(PROJECT_DIR)/$(CSS_SRC)
	@mkdir -p $(PROJECT_DIR)/$(VIEW_SRC)
	@mkdir -p $(PROJECT_DIR)/$(JS_LIB_SRC)
	@mkdir -p $(PROJECT_DIR)/$(IMG_SRC)
	@#silence nothing to be done

get-mustache:
	$(info Fetching Mustache...)
	$(shell curl -s https://raw.github.com/janl/mustache.js/master/mustache.js > $(PROJECT_DIR)/$(JS_LIB_SRC)/mustache.js)
	$(info Minifying Mustache...)
	$(shell java -jar $(TOOLS_DIR)/scriptyhc.jar --minify $(PROJECT_DIR)/$(JS_LIB_SRC)/mustache.js)
	$(shell rm $(PROJECT_DIR)/$(JS_LIB_SRC)/mustache.js)
	@#silence nothing to be done

get-jquery:
	$(info Fetching jQuery...)
	$(shell curl -s http://code.jquery.com/jquery-latest.min.js > $(PROJECT_DIR)/$(JS_LIB_SRC)/jquery.min.js)
	@#silence nothing to be done

css: $(CSS_FILES)
js: $(VIEW_FILES)

$(VIEW_FILES):
	@# do stuff with the view files here if necessary

$(CSS_FILES):
	$(info [Compiling] $(PROJECT_DIR)/$(CSS_OUT)/$(call cssforscss, $@))
	@sass --style compressed $@ $(PROJECT_DIR)/$(CSS_OUT)/$(call cssforscss, $@)

%.css: $(PROJECT_DIR)/$(CSS_SRC)/%.scss

css-watch: 
	@sass --style extended --watch $(PROJECT_DIR)/$(CSS_SRC):$(PROJECT_DIR)/$(CSS_OUT)

dist: distclean installdirs dist-copy-css dist-copy-views dist-copy-js-libs dist-copy-images dist-compress-js 

dist-copy-css: $(CSS_FILES)
	$(foreach FILE, $^, \
		$(eval $(call copycssfile,$(FILE)))\
	)

dist-copy-images:
	$(info [Copying] Images)
	$(shell cp -r $(PROJECT_DIR)/$(IMG_SRC)/ $(TMP_DIR)/$(IMG_SRC)/)

dist-copy-views: $(VIEW_FILES)
	$(foreach FILE, $^, \
		$(eval $(call copyviewfile,$(FILE)))\
	)

dist-copy-js-libs:
	$(info [Copying] JavaScript Libraries)
	$(shell mkdir -p $(TMP_DIR)/$(JS_LIB_SRC))
	$(shell cp $(PROJECT_DIR)/$(JS_LIB_SRC)/* $(TMP_DIR)/$(JS_LIB_SRC)/)

dist-compress-js:
	$(info [Compressing JavaScript])
	$(shell java -jar $(TOOLS_DIR)/scriptyhc.jar --compiler_base_path $(TOOLS_DIR)/compilers --output_prefix $(TMP_DIR) --js_output_module_path $(JS_SRC) --js_default_module_name $(JS_DEFAULT_MODULE_NAME) $(VIEW_FILES))

installdirs:
	$(info [Creating] Directories)
	@mkdir $(TMP_DIR)
	@mkdir -p $(TMP_DIR)/$(CSS_OUT)
	@mkdir -p $(TMP_DIR)/$(VIEW_SRC)
	@mkdir -p $(TMP_DIR)/$(IMG_SRC)

distclean:
	@rm -rf $(TMP_DIR)

define copycssfile
$$(info [Copying] $$(PROJECT_DIR)/$$(CSS_OUT)/$$(call cssforscss, $(1)))
$$(shell cp $$(PROJECT_DIR)/$$(CSS_OUT)/$$(call cssforscss, $(1)) $$(TMP_DIR)/$$(CSS_OUT)/$$(call cssforscss, $(1)))
endef

define copyviewfile
$$(info [Copying] $(1))
$$(shell mkdir -p $$(TMP_DIR)/$$(dir $(1)))
$$(shell cp $(1) $$(TMP_DIR)/$(1))
endef

cssforscss = $(basename $(notdir $(1))).css
scssforcss = $(basename $(notdir $(1))).scss

.PHONY: new
.PHONY: newdirs
.PHONY: get-mustache
.PHONY: get-jquery
.PHONY: css-watch
.PHONY: css $(CSS_FILES)
.PHONY: js $(VIEW_FILES)
.PHONY: dist
.PHONY: dist-copy-css
.PHONY: dist-copy-views
.PHONY: dist-compress-js
.PHONY: installdirs
.PHONY: distclean