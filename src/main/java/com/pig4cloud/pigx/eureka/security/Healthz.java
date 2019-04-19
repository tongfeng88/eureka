package com.pig4cloud.pigx.eureka.security;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "/")
public class Healthz {
    @GetMapping(path = "/healthz",produces = MediaType.TEXT_PLAIN_VALUE)
    public String healthz(){
        return "ok";
    }
}