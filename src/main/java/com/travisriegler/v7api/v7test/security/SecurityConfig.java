package com.travisriegler.v7api.v7test.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(c -> c.disable())
                .cors(cors -> cors
                        .configurationSource(request -> {
                            CorsConfiguration config = new CorsConfiguration();
                            config.setAllowCredentials(true);
                            config.addAllowedOriginPattern("*");
                            config.addAllowedMethod("*");
                            config.addAllowedHeader("*");
                            return config;
                        })
                )
                .headers(h -> h
                        .contentSecurityPolicy(p -> p
                                .policyDirectives("frame-ancestors 'self'")
                        )
                )
                .authorizeHttpRequests(r -> r
                        .anyRequest().permitAll());

        return http.build();
    }
}

