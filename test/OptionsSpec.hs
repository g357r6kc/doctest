module OptionsSpec (spec) where

import           Test.Hspec
import           Test.QuickCheck

import           Options

spec :: Spec
spec = do
  describe "parseOptions" $ do
    let warning = ["WARNING: --optghc is deprecated, doctest now accepts arbitrary GHC options\ndirectly."]
    it "strips --optghc" $
      property $ \xs ys ->
        parseOptions (xs ++ ["--optghc", "foobar"] ++ ys) `shouldBe` Result (Run warning (xs ++ ["foobar"] ++ ys) True False)

    it "strips --optghc=" $
      property $ \xs ys ->
        parseOptions (xs ++ ["--optghc=foobar"] ++ ys) `shouldBe` Result (Run warning (xs ++ ["foobar"] ++ ys) True False)

    describe "--no-magic" $ do
      context "without --no-magic" $ do
        it "enables magic mode" $ do
          runMagicMode <$> parseOptions [] `shouldBe` Result True

      context "with --no-magic" $ do
        it "disables magic mode" $ do
          runMagicMode <$> parseOptions ["--no-magic"] `shouldBe` Result False

    describe "--fast" $ do
      context "without --fast" $ do
        it "disables fast mode" $ do
          runFastMode <$> parseOptions [] `shouldBe` Result False

      context "with --fast" $ do
        it "enabled fast mode" $ do
          runFastMode <$> parseOptions ["--fast"] `shouldBe` Result True

    context "with --help" $ do
      it "outputs usage information" $ do
        parseOptions ["--help"] `shouldBe` Output usage

    context "with --version" $ do
      it "outputs version information" $ do
        parseOptions ["--version"] `shouldBe` Output versionInfo

    context "with --info" $ do
      it "outputs machine readable version information" $ do
        parseOptions ["--info"] `shouldBe` Output info