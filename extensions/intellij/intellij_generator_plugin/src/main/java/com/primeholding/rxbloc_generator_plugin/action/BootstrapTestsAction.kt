package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent

class BootstrapTestsAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent?) {
        e?.project?.baseDir?.let {

            //the folder that contains lib, test, etc...
            val baseProjectDir = it



        }
    }
}