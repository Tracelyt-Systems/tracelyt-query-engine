package io.tracelyt.queryengine;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Entry point for Tracelyt Query Engine application foundation.
 * This class provides minimal bootstrapping for the Spring ApplicationContext.
 */
@SpringBootApplication
public class QueryEngineApplication {

    /**
     * Main application method.
     *
     * @param args runtime command-line arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(QueryEngineApplication.class, args);
    }
}
