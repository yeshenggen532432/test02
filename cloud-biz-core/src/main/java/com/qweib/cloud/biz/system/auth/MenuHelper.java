package com.qweib.cloud.biz.system.auth;

import com.qweib.commons.Encodes;

import java.util.List;
import java.util.Map;

/**
 * @author: jimmy.lin
 * @time: 2019/11/15 11:25
 * @description:
 */
public class MenuHelper {
    private MenuHelper() {
    }

    //TODO 斜杠处理
    public static String trim(String menu) {
        if (menu.startsWith("/")) {
            menu = menu.substring(1);
        }
        if(menu.startsWith("manager/")){
            menu = menu.replace("manager/", "");
        }
        return menu;
    }

    public static byte[] init(int size) {
        byte[] bytes;
        if (size % 8 == 0) {
            bytes = new byte[size / 8];
        } else {
            bytes = new byte[size / 8 + 1];
        }
        return bytes;
    }

    public static String getPermissions(Map<String, Integer> menuMap, List<String> memberMenus) {
        byte[] permission = init(menuMap.size());
        for (String menu : memberMenus) {
            Integer pos = menuMap.get(menu);
            if (pos != null) {
                int bitPosition = pos % 8;
                int bytePosition = pos / 8;
                permission[bytePosition] |= 1 << bitPosition;
            }
        }
        return Encodes.encodeHex(permission);
    }

    public static boolean hasPermission(String req, Map<String, Integer> menuMap, String permission) {
        req = trim(req);
        Integer w = menuMap.get(req);
        if (w == null) {
            return true;
        }
        byte[] permissions = Encodes.decodeHex(permission);
        byte b = permissions[w / 8];
        return (b >> (w % 8) & 1) > 0;
    }

}
