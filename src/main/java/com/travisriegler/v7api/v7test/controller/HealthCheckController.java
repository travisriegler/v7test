package com.travisriegler.v7api.v7test.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
public class HealthCheckController {

    private final String instanceUuid = UUID.randomUUID().toString();

    @GetMapping("/healthcheck")
    public ResponseEntity<String> checkHealth() {
        return ResponseEntity.ok("healthy, instance-uuid: " + instanceUuid);
    }
}

