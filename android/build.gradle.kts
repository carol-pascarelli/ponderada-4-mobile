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
}
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            extensions.findByType(com.android.build.api.dsl.ApplicationExtension::class.java)?.apply {
                compileSdk = 36
            }
            extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)?.apply {
                compileSdk = 36
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
