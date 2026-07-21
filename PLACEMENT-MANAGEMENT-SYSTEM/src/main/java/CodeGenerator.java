import java.time.LocalDate;
import java.util.Random;

public class CodeGenerator {

	public static String generateCompanyCode() {

		// Current Date
		LocalDate date = LocalDate.now();

		// Format Date as YYYY/MM/DD
		String formattedDate =
				date.getYear() + "/"
				+ String.format("%02d", date.getMonthValue()) + "/"
				+ String.format("%02d", date.getDayOfMonth());

		// Random Number between 100 and 499
		Random random = new Random();

		int randomNumber =
				100 + random.nextInt(400);

		// Final Company Code
		return "CMP-"
				+ formattedDate
				+ "-"
				+ randomNumber;
	}
}
