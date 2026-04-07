allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build/host"))

subprojects {
    project.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build/${project.name}"))
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    project.plugins.withId("com.android.library") {
        val extension = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension ?: return@withId
        if (extension.namespace == null) {
            val manifestFile = project.file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val content = manifestFile.readText()
                val packageName = Regex("package=\"([^\"]*)\"").find(content)?.groupValues?.get(1)
                if (packageName != null) {
                    extension.namespace = packageName
                    // Generate a temporary manifest without the package attribute to avoid AGP 8.x clashing
                    val tmpDir = File(project.buildDir, "intermediates/manifest_fix")
                    tmpDir.mkdirs()
                    val tmpManifest = File(tmpDir, "AndroidManifest.xml")
                    tmpManifest.writeText(content.replace("package=\"$packageName\"", ""))
                    extension.sourceSets.getByName("main").manifest.srcFile(tmpManifest)
                } else {
                    extension.namespace = "com.example.${project.name.replace("-", "_")}"
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
