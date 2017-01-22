function escape(string) {
    return string ? String(string).replace(/[&<>"']/g, function(match) {
        return {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        }[match];
    }) : '';
}

$('#receiverid').select3({
    allowClear: true,
    items: cities,
    placeholder: 'No user selected'
});

