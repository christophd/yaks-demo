import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = { "tests" },
        extraGlue = {
                "org.citrusframework.yaks.standard",
                "org.citrusframework.yaks.http",
                "org.citrusframework.yaks.openapi",
                "org.citrusframework.yaks.kafka",
                "org.citrusframework.yaks.groovy",
                "org.citrusframework.yaks.camel",
                "org.citrusframework.yaks.camelk",
                "org.citrusframework.yaks.testcontainers",
                "org.citrusframework.yaks.selenium"
        },
        plugin = { "org.citrusframework.yaks.report.TestReporter" }
)
public class FoodMarketFeatureTest {
}
