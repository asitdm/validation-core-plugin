declare module '@capacitor/core' {
      interface PluginRegistry {
              ValidationCorePlugin: ValidationCorePlugin;
                }
}

export interface ValidationCorePlugin {
      setup(options: { trustlistUrl: string; signatureUrl: string; trustAnchor: string; });
      validate(options: { qrString: string }): Promise<{ result: string }>;
}
