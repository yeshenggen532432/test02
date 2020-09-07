package com.qweib.cloud.utils;

import java.util.Map;
import java.util.Optional;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2020/2/17 - 15:42
 */
public class DataCacheUtils {

    public static <K, V> V getData(Map<K, V> cache, K key, DataListener<K, V> listener) {
        return Optional.ofNullable(cache.get(key))
                .orElseGet(() -> {
                    V tmpValue = listener.get(key);
                    cache.put(key, tmpValue);
                    return tmpValue;
                });
    }

    public interface DataListener<K, V> {

        V get(K key);
    }
}
