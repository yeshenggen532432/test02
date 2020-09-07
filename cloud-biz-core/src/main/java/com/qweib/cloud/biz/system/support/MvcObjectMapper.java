package com.qweib.cloud.biz.system.support;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.fasterxml.jackson.module.jaxb.JaxbAnnotationModule;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.commons.Encodes;
import com.qweib.commons.security.Digests;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

/**
 * @author: jimmy.lin
 * @time: 2019/4/8 10:28
 * @description:
 */
public class MvcObjectMapper extends ObjectMapper {
    private static final long serialVersionUID = 1L;
    private static Logger logger = LoggerFactory.getLogger(MvcObjectMapper.class);
    private static MvcObjectMapper mapper;

    public MvcObjectMapper() {
        this(JsonInclude.Include.ALWAYS);
    }

    public MvcObjectMapper(JsonInclude.Include include) {
        if (include != null) {
            this.setSerializationInclusion(include);
        }

        this.enableSimple();
        this.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
       /* this.getSerializerProvider().setNullValueSerializer(new JsonSerializer<Object>() {
            public void serialize(Object value, JsonGenerator jgen, SerializerProvider provider) throws IOException, JsonProcessingException {
                jgen.writeString("");
            }
        });
        this.registerModule((new SimpleModule()).addSerializer(String.class, new JsonSerializer<String>() {
            public void serialize(String value, JsonGenerator jgen, SerializerProvider provider) throws IOException, JsonProcessingException {
                jgen.writeString(StringEscapeUtils.unescapeHtml4(value));
            }
        }));*/
        this.setTimeZone(TimeZone.getDefault());
    }

    public static MvcObjectMapper getInstance() {
        if (mapper == null) {
            mapper = (new MvcObjectMapper()).enableSimple();
        }

        return mapper;
    }

    public static MvcObjectMapper nonDefaultMapper() {
        if (mapper == null) {
            mapper = new MvcObjectMapper(JsonInclude.Include.NON_DEFAULT);
        }

        return mapper;
    }

    public String toJson(Object object) {
        try {
            return this.writeValueAsString(object);
        } catch (IOException var3) {
            logger.warn("write to json string error:" + object, var3);
            return null;
        }
    }

    public <T> T fromJson(String jsonString, Class<T> clazz) {
        if (StringUtils.isEmpty(jsonString)) {
            return null;
        } else {
            try {
                return this.readValue(jsonString, clazz);
            } catch (IOException var4) {
                logger.warn("parse json string error:" + jsonString, var4);
                return null;
            }
        }
    }

    public <T> T fromJson(String jsonString, JavaType javaType) {
        if (StringUtils.isEmpty(jsonString)) {
            return null;
        } else {
            try {
                return this.readValue(jsonString, javaType);
            } catch (IOException var4) {
                logger.warn("parse json string error:" + jsonString, var4);
                return null;
            }
        }
    }

    public JavaType createCollectionType(Class<?> collectionClass, Class... elementClasses) {
        return this.getTypeFactory().constructParametricType(collectionClass, elementClasses);
    }

    public <T> T update(String jsonString, T object) {
        try {
            return this.readerForUpdating(object).readValue(jsonString);
        } catch (JsonProcessingException var4) {
            logger.warn("update json string:" + jsonString + " to object:" + object + " error.", var4);
        } catch (IOException var5) {
            logger.warn("update json string:" + jsonString + " to object:" + object + " error.", var5);
        }

        return null;
    }

    public String toJsonP(String functionName, Object object) {
        return this.toJson(new JSONPObject(functionName, object));
    }

    public MvcObjectMapper enableEnumUseToString() {
        this.enable(SerializationFeature.WRITE_ENUMS_USING_TO_STRING);
        this.enable(DeserializationFeature.READ_ENUMS_USING_TO_STRING);
        return this;
    }

    public MvcObjectMapper enableJaxbAnnotation() {
        JaxbAnnotationModule module = new JaxbAnnotationModule();
        this.registerModule(module);
        return this;
    }

    public MvcObjectMapper enableSimple() {
        this.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
        this.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);
        return this;
    }

    public ObjectMapper getMapper() {
        return this;
    }

    public static String toJsonString(Object object) {
        return getInstance().toJson(object);
    }

    public static <T> T fromJsonString(String jsonString, Class<T> clazz) {
        return getInstance().fromJson(jsonString, clazz);
    }

    public static void main(String[] args) {
        List<Map<String, Object>> list = Lists.newArrayList();
        Map<String, Object> map = Maps.newHashMap();
        map.put("id", 1);
        map.put("pId", -1);
        map.put("name", "根节点");
        list.add(map);
        map = Maps.newHashMap();
        map.put("id", 2);
        map.put("pId", 1);
        map.put("name", "你好");
        map.put("open", true);
        list.add(map);
        String json = getInstance().toJson(list);
        System.out.println(json);

        SysBforderDetail order = new SysBforderDetail();
        order.setWareDj(null);
        order.setXsTp("xx");

        System.out.println(getInstance().toJson(order));

        System.out.println(Encodes.encodeHex(Digests.md5("123654".getBytes())));

    }

}
