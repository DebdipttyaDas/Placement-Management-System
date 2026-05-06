import java.util.UUID;

public class CodeGenerator {
    public static String generateCompanyCode() {
        // Format: CMP-XXXXXXXX
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
        return "CMP-" + uuid;
    }
}
