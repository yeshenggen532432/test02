package com.qweib.cloud.repository.utils;

import com.qweibframework.commons.http.ResponseUtils;
import com.qweibframework.commons.web.dto.Response;
import org.dozer.Mapper;
import retrofit2.Call;

/**
 * Description:
 *
 * @author zeng.gui
 * Created on 2019/3/1 - 11:36
 */
public class HttpResponseUtils {

    /**
     * 转换 http 响应，失败则抛出异常
     *
     * @param call
     * @param <E>
     * @return
     */
    public static <E> E convertResponse(Call<Response<E>> call) {
        return ResponseUtils.convertResponse(call);
    }

    /**
     * 转换 http 响应，失败则返回 null
     *
     * @param call
     * @param <E>
     * @return
     */
    public static <E> E convertResponseNull(Call<Response<E>> call) {
        return ResponseUtils.convertResponseNull(call);
    }

    public static <E, T> T convertToEntity(Call<Response<E>> call, Class<T> clazz, Mapper mapper) {
        E data = convertResponseNull(call);
        if (data != null) {
            return mapper.map(data, clazz);
        } else {
            return null;
        }
    }
}
