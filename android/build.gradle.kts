allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Interception pour forcer le namespace sur les vieux plugins (ex: isar)
    afterEvaluate {
        val proj = this
        if (proj.hasProperty("android")) {
            val androidExt = proj.extensions.findByName("android")
            if (androidExt != null) {
                try {
                    val namespaceProperty = androidExt.javaClass.getMethod("getNamespace").invoke(androidExt)
                    if (namespaceProperty == null || (namespaceProperty as? String)?.isEmpty() == true) {
                        val groupProp = proj.group.toString()
                        if (groupProp.isNotEmpty()) {
                            androidExt.javaClass.getMethod("setNamespace", String::class.java).invoke(androidExt, groupProp)
                        }
                    }
                } catch (e: Exception) {
                    // Ignore les plugins qui ne supportent pas cette propriété
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
