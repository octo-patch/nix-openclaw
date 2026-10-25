import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const gatewayEntry = fileURLToPath(import.meta.resolve("openclaw"));
const gatewayDist = path.dirname(gatewayEntry);
const bundledEntry = path.join(gatewayDist, "extensions", "minimax", "index.js");
const bundledPlugin = await import(pathToFileURL(bundledEntry).href);

export default bundledPlugin.default;
