// Конфігурація логування
const DEBUG = true;

function log(...args) {
    if (DEBUG) {
        console.log('%c[ACCOUNT_UI]', 'color: #00f2fe; font-weight: bold;', ...args);
    }
}

function error(...args) {
    console.error('%c[ACCOUNT_UI_ERROR]', 'color: #ff0000; font-weight: bold;', ...args);
}

// Елементи DOM
const elements = {
    container: document.getElementById('container'),
    formContainer: document.getElementById('form-container'),
    serverName: document.getElementById('server-name'),
    messageBox: document.getElementById('message'),
    forms: {
        login: document.getElementById('login-form'),
        register: document.getElementById('register-form'),
        recovery: document.getElementById('recovery-form')
    },
    inputs: {
        loginUsername: document.getElementById('login-username'),
        loginPassword: document.getElementById('login-password'),
        regUsername: document.getElementById('reg-username'),
        regEmail: document.getElementById('reg-email'),
        regPassword: document.getElementById('reg-password'),
        regConfirm: document.getElementById('reg-confirm'),
        recDiscord: document.getElementById('rec-discord'),
        recCode: document.getElementById('rec-code'),
        recNewPassword: document.getElementById('rec-new-password')
    },
    buttons: {
        requestCode: document.getElementById('request-code'),
        resetBtn: document.getElementById('reset-btn')
    }
};

// Перевірка на наявність всіх критичних елементів
function validateDOM() {
    for (const [key, value] of Object.entries(elements.forms)) {
        if (!value) {
            error(`Форма ${key} не знайдена в HTML!`);
            return false;
        }
    }
    if (!elements.messageBox) {
        error('Елемент повідомлень не знайдений!');
        return false;
    }
    return true;
}

document.addEventListener('DOMContentLoaded', () => {
    log('DOM завантажено. Перевірка елементів...');
    if (!validateDOM()) {
        error('Критична помилка DOM. Перевірте index.html');
        return;
    }
    log('Всі елементи знайдено. Ініціалізація слухачів подій...');
    initEventListeners();
    
    // Перевірка збереженого значення галочки "Запам'ятати мене"
    const savedRememberMe = localStorage.getItem('rememberMeChecked');
    const rememberMeCheckbox = document.getElementById('remember-me');
    if (rememberMeCheckbox) {
        if (savedRememberMe === 'true') {
            rememberMeCheckbox.checked = true;
        } else {
            rememberMeCheckbox.checked = false;
        }
        
        // Слухач на зміну галочки для миттєвого збереження стану
        rememberMeCheckbox.addEventListener('change', (e) => {
            localStorage.setItem('rememberMeChecked', e.target.checked);
        });
    }
});

// Слухачі подій
function initEventListeners() {
    // Перемикання форм
    document.querySelectorAll('.switch-form a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetForm = link.getAttribute('data-form');
            log(`Перемикання на форму: ${targetForm}`);
            switchForm(targetForm);
        });
    });

    // Обробка форми реєстрації
    elements.forms.register.addEventListener('submit', async (e) => {
        e.preventDefault();
        await handleRegister();
    });

    // Обробка форми входу
    elements.forms.login.addEventListener('submit', async (e) => {
        e.preventDefault();
        await handleLogin();
    });

    // Запит коду відновлення
    if (elements.buttons.requestCode) {
        elements.buttons.requestCode.addEventListener('click', async () => {
            await handleRequestCode();
        });
    }

    // Скидання паролю
    elements.forms.recovery.addEventListener('submit', async (e) => {
        e.preventDefault();
        await handleResetPassword();
    });

    // Клавіша Escape
    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape') {
            log('Натиснуто ESC. Закриття UI.');
            fetch('https://qbx_account_system/close', { method: 'POST' });
        }
    });

    // Отримання повідомлень з Lua
    window.addEventListener('message', (event) => {
        const data = event.data;
        log('Отримано повідомлення з Lua:', data);

        if (data.action === 'open') {
            openUI(data.serverName);
        } else if (data.action === 'close') {
            closeUI();
        }
    });
}

// Логіка UI
function switchForm(formName) {
    Object.values(elements.forms).forEach(form => {
        if (form) form.classList.remove('active');
    });
    
    const target = elements.forms[formName];
    if (target) {
        target.classList.add('active');
        hideMessage();
    } else {
        error(`Форма ${formName} не існує для перемикання.`);
    }
}

function openUI(serverName) {
    try {
        log('Відкриття UI...');
        if (elements.serverName) {
            // Безпечна заміна тексту, уникаємо undefined.replace
            const safeName = typeof serverName === 'string' ? serverName : 'Server';
            elements.serverName.textContent = safeName;
        }

        // Автозаповнення
        const rememberedUsername = localStorage.getItem('rememberedUsername');
        if (rememberedUsername && elements.inputs.loginUsername) {
            elements.inputs.loginUsername.value = rememberedUsername;
        }

        document.body.style.display = 'flex';
        // Невеликий таймаут для плавності (опціонально)
        setTimeout(() => {
            if (elements.container) elements.container.style.opacity = '1';
        }, 10);
        
        log('UI відкрито.');
    } catch (err) {
        error('Помилка при відкритті UI:', err);
    }
}

function closeUI() {
    log('Закриття UI...');
    document.body.style.display = 'none';
    hideMessage();
    // Скидання активної форми на логін
    switchForm('login');
}

function showMessage(text, type) {
    if (!elements.messageBox) return;
    
    elements.messageBox.textContent = text;
    elements.messageBox.className = type; // 'success' або 'error'
    elements.messageBox.style.display = 'block';
    
    log(`Повідомлення (${type}):`, text);
    
    // Автоматичне приховування через 5 сек
    setTimeout(hideMessage, 5000);
}

function hideMessage() {
    if (!elements.messageBox) return;
    elements.messageBox.style.display = 'none';
    elements.messageBox.className = '';
}

// API Виклики
async function fetchNUI(endpoint, data) {
    try {
        const response = await fetch(`https://qbx_account_system/${endpoint}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data || {})
        });
        return await response.json();
    } catch (err) {
        error(`Помилка запиту до ${endpoint}:`, err);
        return { success: false, message: 'Помилка мережі (перевірте консоль)' };
    }
}

async function handleRegister() {
    const username = elements.inputs.regUsername?.value.trim();
    const email = elements.inputs.regEmail?.value.trim();
    const password = elements.inputs.regPassword?.value;
    const confirm = elements.inputs.regConfirm?.value;

    if (!username || !email || !password) {
        showMessage('Заповніть всі поля!', 'error');
        return;
    }

    if (password.length < 6) {
        showMessage('Пароль має бути не менше 6 символів!', 'error');
        return;
    }

    if (password !== confirm) {
        showMessage('Паролі не співпадають!', 'error');
        return;
    }

    if (username.length < 4) {
        showMessage('Логін має бути не менше 4 символів!', 'error');
        return;
    }

    showMessage('Реєстрація...', 'success');
    const result = await fetchNUI('register', { username, email, password });
    
    if (result.message) {
        showMessage(result.message, result.success ? 'success' : 'error');
    }
}

async function handleLogin() {
    const username = elements.inputs.loginUsername?.value.trim();
    const password = elements.inputs.loginPassword?.value;
    const rememberMe = document.getElementById('remember-me')?.checked || false;

    if (!username || !password) {
        showMessage('Введіть логін та пароль!', 'error');
        return;
    }

    if (rememberMe) {
        localStorage.setItem('rememberedUsername', username);
    } else {
        localStorage.removeItem('rememberedUsername');
    }

    showMessage('Вхід...', 'success');
    const result = await fetchNUI('login', { username, password });
    
    if (result.message) {
        showMessage(result.message, result.success ? 'success' : 'error');
    }
}

async function handleRequestCode() {
    const discordId = elements.inputs.recDiscord?.value.trim();
    if (!discordId) {
        showMessage('Введіть Discord ID!', 'error');
        return;
    }

    const result = await fetchNUI('requestRecovery', { discordId });
    showMessage(result.message, result.success ? 'success' : 'error');
    
    if (result.success) {
        if (elements.inputs.recCode) elements.inputs.recCode.style.display = 'block';
        if (elements.inputs.recNewPassword) elements.inputs.recNewPassword.style.display = 'block';
        if (elements.buttons.resetBtn) elements.buttons.resetBtn.style.display = 'block';
    }
}

async function handleResetPassword() {
    const discordId = elements.inputs.recDiscord?.value.trim();
    const code = elements.inputs.recCode?.value.trim();
    const newPassword = elements.inputs.recNewPassword?.value;

    if (!code || !newPassword) {
        showMessage('Введіть код та новий пароль!', 'error');
        return;
    }

    const result = await fetchNUI('resetPassword', { discordId, code, newPassword });
    showMessage(result.message, result.success ? 'success' : 'error');
}