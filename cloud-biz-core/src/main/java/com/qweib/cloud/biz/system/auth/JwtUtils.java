package com.qweib.cloud.biz.system.auth;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

import java.util.Date;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

/**
 * @author jimmy.lin
 * create at 2020/4/17 19:10
 */
public class JwtUtils {
    private static final String DEFAULT_SECRET = "uglcw123123";

    private JwtUtils() {
    }

    public static String gen(JwtPayload payload, String secret) {
        Algorithm algorithm = Algorithm.HMAC256(Optional.ofNullable(secret).orElse(DEFAULT_SECRET));
        return JWT.create()
                .withClaim("userId", payload.getUserId())
                .withClaim("companyId", payload.getCompanyId())
                .withClaim("mobile", payload.getMobile())
                .withExpiresAt(new Date(System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(1)))
                .sign(algorithm);
    }

    public static String gen(JwtPayload payload) {
        return gen(payload, null);
    }

    public static JwtPayload decode(String token, String secret) {
        Algorithm algorithm = Algorithm.HMAC256(Optional.ofNullable(secret).orElse(DEFAULT_SECRET));
        JWTVerifier verifier = JWT.require(algorithm).build();
        DecodedJWT jwt = verifier.verify(token);
        return JwtPayload.builder()
                .userId(jwt.getClaim("userId").asInt())
                .companyId(jwt.getClaim("companyId").asInt())
                .mobile(jwt.getClaim("mobile").asString())
                .build();
    }

    public static JwtPayload decode(String token) {
        return decode(token, null);
    }


    public static void main(String[] args) {

      /*  JwtPayload payload = decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55SWQiOjU5MCwiZXhwIjoxNTg3MzQ4MDI5LCJ1c2VySWQiOjQwMzJ9._CT05O950zTcl4ly2ozq9YbF12GQN8rb6GpojZqvtHU");
        System.out.println(payload.getCompanyId());
*/

        String token = gen(JwtPayload.builder()
                .companyId(590)
                .userId(2231)
                .build(), "1234");
        System.out.println(token);
        JwtPayload payload = decode(token, "1234");
        System.out.println(payload.getUserId());
        System.out.println(payload.getCompanyId());
    }


}
