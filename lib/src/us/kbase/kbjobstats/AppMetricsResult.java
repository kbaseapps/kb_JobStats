
package us.kbase.kbjobstats;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: AppMetricsResult</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "job_states"
})
public class AppMetricsResult {

    @JsonProperty("job_states")
    private List<Map<String, String>> jobStates;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("job_states")
    public List<Map<String, String>> getJobStates() {
        return jobStates;
    }

    @JsonProperty("job_states")
    public void setJobStates(List<Map<String, String>> jobStates) {
        this.jobStates = jobStates;
    }

    public AppMetricsResult withJobStates(List<Map<String, String>> jobStates) {
        this.jobStates = jobStates;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((("AppMetricsResult"+" [jobStates=")+ jobStates)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
