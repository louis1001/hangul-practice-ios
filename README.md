# Hangul Practice (iOS)
An app to practice your Hangul reading. Something I needed for my own study, and hope that it help someone else.

---

<p style="display: flex; justify-content: space-around">
  <img src="https://user-images.githubusercontent.com/26968689/207396191-76c79d52-178f-41cf-afd2-bea29f17c133.png" width="100" />
  <img src="https://user-images.githubusercontent.com/26968689/207396202-6f4785d4-5346-46d4-a20d-d1f0e00954f9.png" width="100" /> 
  <img src="https://user-images.githubusercontent.com/26968689/207396208-8329bbd0-8f2d-4607-8efe-252f16c5bb6a.png" width="100" />
</p>

- It has a dataset of the most common korean words. https://github.com/uniglot/korean-word-ipa-dictionary
- Picks a random word from the dataset and shows it.
- Breaks down the word into characters so you can see them individually.
(using [this port I made](https://github.com/louis1001/hangul-dis-assemble) of a Hangul processing library)
- Checks if the devices dictionaries have definition for the word, and shows it to you.
- Fetches the translation from google translate
- Allows playback of the word using iOS' speech synthesizer. (Siri)

## Caveats

The pronunciation guide is **not correct**. Or it most likely isn't. You should not rely on it, and it's better if you
talk **to someone who knows the language** to check your pronunciation.
The _play_ button is only meant as a guide to help you remember what sound a particular character makes.
