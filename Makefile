include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-serverchan
PKG_VERSION:=2.01.4
PKG_RELEASE:=10  # 更新RELEASE号以表示修改

PKG_MAINTAINER:=tty228 <tty228@yeah.net>

# 明确指定分类，确保出现在LuCI Applications中
LUCI_TITLE:=LuCI Support for ServerChan
LUCI_DEPENDS:=+arping +curl +jq  # 修正依赖包名称（iputils-arping -> arping）
LUCI_CATEGORY:=Utilities  # 添加分类
LUCI_PKGARCH:=all

# 配置文件路径需匹配实际安装位置
define Package/$(PKG_NAME)/conffiles
/etc/config/serverchan
/etc/serverchan/api/diy.json  # 调整路径至/etc下避免运行时权限问题
/etc/serverchan/api/logo.jpg
/etc/serverchan/api/ipv4.list
/etc/serverchan/api/ipv6.list
endef

# 定义安装步骤，确保文件复制到正确路径
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

# 包含LuCI构建模块（路径根据实际位置调整）
include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
