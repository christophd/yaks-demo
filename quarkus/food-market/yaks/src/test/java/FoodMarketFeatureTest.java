import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        extraGlue = "org.citrusframework.yaks",
        plugin = { "pretty", "org.citrusframework.yaks.report.TestReporter" }
)
public class FoodMarketFeatureTest {
}
