@echo off

cd "C:\kcw\Locales_Kaltura_ContributionWizard"

mxmlc -locale=en_US -source-path=locale/{locale} -include-resource-bundles=CairngormMessages,Errors,FinishScreen,ImportBrowser,ImportModuleLoader,IntroScreen,MediaTypes,PendingMessages,SearchAuthenticationScreen,SearchImportView,Tagging,TermsOfUseScreen,UploadImportView,WebcamView,SoundRecorderView,collections,containers,controls,core,effects,logging,messaging,rpc,skins,states,styles,SharedResources,PendingMessages,PermissionLevels,MediaProviders -output=en_US_ContributionWizard_kaltura.swf