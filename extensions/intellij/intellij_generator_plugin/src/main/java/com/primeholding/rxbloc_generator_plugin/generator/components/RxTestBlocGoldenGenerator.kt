package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass

class RxTestBlocGoldenGenerator(val name: String, projectName: String, bloc: TestableClass) :
RxTestGeneratorBase(name, templateName = "bloc_golden", projectName = projectName, bloc = bloc) {

    override fun fileName() = "${snakeCase()}_golden_test.${fileExtension()}"
    override fun contextDirectoryName(): String = "view"
}