include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-serverchan
PKG_VERSION:=2.01.4
PKG_RELEASE:=10  # 更新RELEASE号

PKG_MAINTAINER:=tty228 <tty228@yeah.net>

# LuCI元数据
LUCI_TITLE:=LuCI Support for ServerChan  # 标题首字母大写
LUCI_DEPENDS:=+arping +curl +jq         # 修正依赖名称
LUCI_CATEGORY:=Utilities               # 明确分类
LUCI_PKGARCH:=all

# 配置文件路径修正
define Package/$(PKG_NAME)/conffiles
/etc/config/serverchan
/etc/serverchan/api/diy.json
/etc/serverchan/api/logo.jpg
/etc/serverchan/api/ipv4.list
/etc/serverchan/api/ipv6.list
endef

# 定义文件安装步骤
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/serverchan.config $(1)/etc/config/serverchan

	$(INSTALL_DIR) $(1)/etc/serverchan/api
	$(INSTALL_DATA) ./files/api/diy.json $(1)/etc/serverchan/api/
	$(INSTALL_DATA) ./files/api/logo.jpg $(1)/etc/serverchan/api/
	$(INSTALL_DATA) ./files/api/ipv4.list $(1)/etc/serverchan/api/
	$(INSTALL_DATA) ./files/api/ipv6.list $(1)/etc/serverchan/api/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/serverchan.lua $(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/serverchan.lua $(1)/usr/lib/lua/luci/model/cbi/
endef

# 使用绝对路径包含luci.mk
include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
