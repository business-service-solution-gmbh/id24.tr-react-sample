import React, { useState } from 'react';
import { View, Text, TextInput, Button, Image, StyleSheet, TouchableOpacity, TouchableWithoutFeedback, Keyboard } from 'react-native';
import { NativeModules } from 'react-native';
const { IdentifyModule } = NativeModules;

const App = () => {
  const [identId, setIdentId] = useState('');
  const [selectedLanguage, setSelectedLanguage] = useState('tr');
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const languages = [
    { label: 'Türkçe', value: 'tr' },
    { label: 'İngilizce', value: 'en' },
    { label: 'Almanca', value: 'de' },
    { label: 'Rusça', value: 'ru' },
    { label: 'Azerice', value: 'az' },
  ];

  const handlePress = async () => {
    const apiUrl = "https://api.id24tr-qa.bssgmbh.works";
    const currentId = identId;
    try {
      const result = await IdentifyModule.startIdentification(apiUrl, currentId, selectedLanguage);
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
      <View style={styles.container}>
        <Image source={require('./identifyLogo.png')} style={styles.logo} resizeMode="contain" />
        <TextInput
          style={styles.input}
          placeholder="identId"
          placeholderTextColor="#bbb"
          value={identId}
          onChangeText={setIdentId}
        />
        <TouchableOpacity style={styles.dropdownButton} onPress={() => setDropdownOpen(!dropdownOpen)}>
          <Text style={styles.dropdownButtonText}>
            {languages.find(lang => lang.value === selectedLanguage)?.label || 'Dil Seçiniz'}
          </Text>
        </TouchableOpacity>
        {dropdownOpen && (
          <View style={styles.dropdown}>
            <Text style={styles.dropdownHeader}>Lütfen SDK Dilini Seçiniz</Text>
            {languages.map((language) => (
              <TouchableOpacity
                key={language.value}
                style={styles.dropdownItem}
                onPress={() => {
                  setSelectedLanguage(language.value);
                  setDropdownOpen(false);
                }}
              >
                <Text style={styles.dropdownItemText}>{language.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
        <View style={styles.buttonContainer}>
          <Button title="Bağlan" onPress={handlePress} />
        </View>
      </View>
    </TouchableWithoutFeedback>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#003366',
  },
  logo: {
    width: '50%',
    height: 100,
    marginBottom: 10,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    width: '80%',
    marginBottom: 20,
    paddingHorizontal: 10,
    borderRadius: 5,
    backgroundColor: '#fff',
  },
  dropdownButton: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    width: '80%',
    justifyContent: 'center',
    paddingHorizontal: 10,
    borderRadius: 5,
    backgroundColor: '#fff',
    marginBottom: 20,
  },
  dropdownButtonText: {
    fontSize: 16,
    color: 'black',
  },
  dropdown: {
    width: '80%',
    borderColor: 'gray',
    borderWidth: 1,
    borderRadius: 5,
    backgroundColor: '#fff',
    marginBottom: 20,
    alignItems: 'center',
  },
  dropdownHeader: {
    fontSize: 16,
    fontWeight: 'bold',
    marginVertical: 10,
  },
  dropdownItem: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: 'gray',
    width: '100%',
    alignItems: 'center',
  },
  dropdownItemText: {
    fontSize: 16,
    color: 'black',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    width: '80%',
  },
});

export default App;